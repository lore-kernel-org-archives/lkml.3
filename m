Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab3GTV3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 17:29:50 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50083 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab3GTV3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 17:29:48 -0400
Message-ID: <51EAF997.2090300@gmail.com>
Date: Sat, 20 Jul 2013 22:56:55 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Peter Schiffer <pschiffe@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-man <linux-man@vger.kernel.org>, benjamin@python.org
Subject: Re: [PATCH] open(2): document O_PATH
References: <CAKgNAkgWiANFA1Z7o2EQmKmsMzzpa1ga2ggLeX3Bo58QmjDx6g@mail.gmail.com> <20130720114017.GA2118@ZenIV.linux.org.uk>
In-Reply-To: <20130720114017.GA2118@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/13 13:40, Al Viro wrote:
> On Thu, Mar 14, 2013 at 10:35:59AM +0100, Michael Kerrisk (man-pages) wrote:
>> Hello Al et al,
>>
>> Documenting O_PATH fell by the wayside last year
>> (http://thread.gmane.org/gmane.linux.man/2790) as I got distracted
>> with other tasks. A recent prod or two have reminded me restart this.
>> I have the following patch queued to document O_PATH.
>>
>> Could you please review. I've provided the O_PATH doc both as
>> formatted text, for ease of reviewing, and as a patch and entire file
>> (attached).
> 
> Seems to be mostly correct; the only thing missing is that F_GETFL is also
> allowed (and return value will contain O_PATH for such descriptors).  Had
> been there since the very beginning...

Thanks, Al. I have added that piece.

Cheers,

Michael

