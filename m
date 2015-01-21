Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbbAUJID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:08:03 -0500
Received: from svenfoo.org ([82.94.215.22]:49018 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbbAUJHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:07:48 -0500
Message-ID: <54BF6C5F.9080008@zonque.org>
Date: Wed, 21 Jan 2015 10:07:43 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
        ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
        jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: daniel@zonque.or, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5F1F.8070703@gmail.com> <54BE957A.60305@zonque.org> <54BF6A13.2090008@gmail.com>
In-Reply-To: <54BF6A13.2090008@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 01/21/2015 09:57 AM, Michael Kerrisk (man-pages) wrote:
> On 01/20/2015 06:50 PM, Daniel Mack wrote:

>> I've addressed all but the below issues, following your suggestions.
> 
> Are your changes already visible somewhere?

Yes, in the upstream repo for the standalone module, which we also use
to build the patch set from:

  https://code.google.com/p/d-bus/source/browse/kdbus.txt

>> Hmm, you're quoting text from section 5, and section 4 actually
>> describes the concept of items quite well I believe?
> 
> Well, Section 4 is pretty short. My point is that most of the various 
> blob formats (e.g., kdbus_pids, kdbus_caps, kdbus_memfd) are not
> documented in kdbus.txt. They all should be, IMO.

Okay, I'll add some text about them.


Best regards,
Daniel

