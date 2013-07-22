Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab3GVIrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:47:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab3GVIrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:47:21 -0400
Message-ID: <51ECF166.4080007@redhat.com>
Date: Mon, 22 Jul 2013 10:46:30 +0200
From: Peter Schiffer <pschiffe@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-man <linux-man@vger.kernel.org>, benjamin@python.org
Subject: Re: [PATCH] open(2): document O_PATH
References: <CAKgNAkgWiANFA1Z7o2EQmKmsMzzpa1ga2ggLeX3Bo58QmjDx6g@mail.gmail.com> <20130720114017.GA2118@ZenIV.linux.org.uk> <51EAF997.2090300@gmail.com>
In-Reply-To: <51EAF997.2090300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2013 10:56 PM, Michael Kerrisk wrote:
> On 07/20/13 13:40, Al Viro wrote:
>> On Thu, Mar 14, 2013 at 10:35:59AM +0100, Michael Kerrisk (man-pages) wrote:
>>> Hello Al et al,
>>>
>>> Documenting O_PATH fell by the wayside last year
>>> (http://thread.gmane.org/gmane.linux.man/2790) as I got distracted
>>> with other tasks. A recent prod or two have reminded me restart this.
>>> I have the following patch queued to document O_PATH.
>>>
>>> Could you please review. I've provided the O_PATH doc both as
>>> formatted text, for ease of reviewing, and as a patch and entire file
>>> (attached).
>>
>> Seems to be mostly correct; the only thing missing is that F_GETFL is also
>> allowed (and return value will contain O_PATH for such descriptors).  Had
>> been there since the very beginning...
>
> Thanks, Al. I have added that piece.
>

Michael,

there is a typo within added piece:

diff --git a/man2/open.2 b/man2/open.2
index c61ea7f..ef0f664 100644
--- a/man2/open.2
+++ b/man2/open.2
@@ -489,7 +489,7 @@ and
  .IP *
  Retrieving open file status flags using the
  .BR fcntl (2)
-.BR F_GETFD
+.BR F_GETFL
  operation: the returned flags will include the bit
  .BR O_PATH .


