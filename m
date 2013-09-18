Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab3IRW0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 18:26:39 -0400
Received: from nm4-vm8.access.bullet.mail.gq1.yahoo.com ([216.39.63.212]:32759
	"EHLO nm4-vm8.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558Ab3IRW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 18:26:37 -0400
X-Yahoo-Newman-Id: 669504.63770.bm@smtp115.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qrQt7fEVM1la4tns01beRAaNVm3mdj.Rn2uZie2XV.yynQ4
 Z0ZZtQUpbTEqVXVvDuJGLPZE85bKVA9zbjMSYpHMqLU2O7jcl9hGWPg_Pkb2
 Ubzz_OKhQOMolkgwBkLBC.JVTNu9YVFuakWf7MU5K6u_wiwOmw.SqjfrQ6WH
 CA47zUaTm25LlFu53MC7xUhBgosbtRgkKOiJunyyrXExL0gtXIcLGfyIlnPT
 1axbhGxsWjAC1ta59JRaEBHcQJ.sPl44rdh29a1Z10yfNirBWLkm1nrbMrl_
 hOuxx9Q3DA4AjXGIzyesxFTguOTZ012Q9mFeVkUHtMRAtOp_uY2waIKwtiNL
 UkNSZuZa1wwIy7tWFL73CukSeJwZ0dAnSjMYq6oYo.alOA6oJytsL4HULMVa
 uRHqU8DhhgPbEh0aRSt5CKyEag0JVblDUwWFyzbp6siRk7OaNzHogG1Ro1LP
 XCwUdl1B51QNWd6hTHlAn3f1.0FY.K7OpXybVIoctGiA8RQNEFPrdtX1i1pw
 M9h2g4hlZjyxjHB0KqFJk9MPxdgnVWy2oW1TWQNmgcEbhcRwm1bwtnl.yWjC
 ISkDv8VFq6QZXdRDo6QTu.N.OrNHyg4.fVgxBfQ1HudrErpPjptZNP1PhfEE
 HpkBI1hNkS3g-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with )
        by smtp115.sbc.mail.gq1.yahoo.com with SMTP; 18 Sep 2013 15:26:36 -0700 PDT
Message-ID: <523A28B7.10703@att.net>
Date: Wed, 18 Sep 2013 17:27:03 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Daniel Santos <daniel.santos@pobox.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 1/5] scripts: Add mkstrerror.sh
References: <29168.1379504300@warthog.procyon.org.uk> <1379459317-13046-2-git-send-email-daniel.santos@pobox.com> <1379459317-13046-1-git-send-email-daniel.santos@pobox.com> <1352.1379505310@warthog.procyon.org.uk>
In-Reply-To: <1352.1379505310@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/18/2013 06:55 AM, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
>
>>   (1) Why are you double-NUL'ing all your strings?  (see the \0 in the strings)
> Ah...  I see what you're doing.  I missed the fact that you don't have a comma
> after each string.

Yeah, I was trying to format the code so that it's efficient and still 
easy to read, but then there's no comma where we normally expect one.  
It's the best middle ground solution I could come up with.

