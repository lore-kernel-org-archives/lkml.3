Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab3IRWr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 18:47:28 -0400
Received: from nm24-vm2.access.bullet.mail.bf1.yahoo.com ([216.109.115.177]:29711
	"EHLO nm24-vm2.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607Ab3IRWr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 18:47:27 -0400
X-Yahoo-Newman-Id: 242888.46553.bm@smtp111.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: nCC9K6sVM1nUubLhrAtb7fJYz7Is6w1mje1cMFH7WTVnbwa
 42RDi16hxSZO0Shzh5eaPnqNRMhsxlyGDWmT.hKl2Rp6cWCeaWEzubtpZ45P
 IThiK50nk4BTJvW0YL4dOme1AwfNZxn2ItE6ntECqK4hw1pYps06FCXkH_wf
 GVhGhS9hId.I7_lILiNTsGdBNsK7igrCVtSemBlFjA4UMRP5DABsH13TJGVz
 5UuJpWYjE6JMRK6qS5MB8bSv_3a8NMdfWItVrbqIk87987gSc56usNQMuuqE
 .Mu8jAe6wrABXfs5KQibQxx8BhXEzbccOqOulEmQPgHSZsugiZVjA64.Wy1a
 zid6Y.HJSRjQhUiINnoPHqNHgBbL6LSNLCYEt6Br.lnTNzMvRvj0KZ.UgxdE
 iXc.OuyBdfcM5dybEjNHYXRkhpZaSX8x45RvyPQ6pBYpqceC6Bs2qtbV8vU3
 uaKoPK0jQMIOZOGwoginDBklFFSuRvtP3_bCTnpffPx.FNG3Ax285i.LvBdH
 H2GTfwP.8f_dCf_jZPyhMp3oT95VsFA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with )
        by smtp111.sbc.mail.bf1.yahoo.com with SMTP; 18 Sep 2013 15:47:26 -0700 PDT
Message-ID: <523A2D99.3040503@att.net>
Date: Wed, 18 Sep 2013 17:47:53 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 0/5] Preliminary: Add error names & descrptions to printks
References: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com> <22288.1379502518@warthog.procyon.org.uk>
In-Reply-To: <22288.1379502518@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/18/2013 06:08 AM, David Howells wrote:
> danielfsantos@att.net wrote:
>
>> Typically, we don't care about error messages or names in the kernel because
>> userspace will manage that.  But sometimes we need to output an error number
>> to printks and that creates a situation where a user, system admistrator or
>> developer must find an error number reference to figure out what went wrong
>> with a particular driver or whatever.  This patch adds two alternatives at
>> increasing memory costs:
>>
>> 1. print the number in addition to the name for 2k extra or
>> 2. print the number, name and description for 6k extra.
> I like the idea generally - and have occasionally entertained the idea of
> implementing it myself.  However, I wouldn't bother with the "human readable"
> description if we're going to do this.  Generally, the symbolic representation
> is good enough - and that's what you're going to grep the code for anyway.
>
> David

Yeah, I thought about that too, but I figured that descriptions were 
already there so I may as well make it an option for the 
search-engine-impared. :)  I was also thinking about system 
administrators and ordinary users trying to installing device drivers 
and other such situations where they would have to look at their syslogs 
or dmesg -- or just the lazy. :)

Daniel
