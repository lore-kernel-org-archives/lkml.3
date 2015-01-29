Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbbA2Bq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:46:29 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:33047 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757711AbbA2BqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:46:24 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2015 20:46:23 EST
Date: Thu, 29 Jan 2015 02:39:18 +0100
From: Alexander Wuerstlein <arw@cs.fau.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Julian Brost <linux-kernel@0x4a42.net>, linux-mei@linux.intel.com,
        linux-kernel@i4.cs.fau.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, fabian.hofmann@fau.de,
        tomas.winkler@intel.com
Subject: Re: [i4passt] [PATCH 1/4] Documentation/misc-devices/mei: Fix
 formatting of headings.
Message-ID: <20150129013918.GB11151@cip.informatik.uni-erlangen.de>
References: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
 <1421020689-28332-2-git-send-email-linux-kernel@0x4a42.net>
 <20150128121709.5b6afb11@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128121709.5b6afb11@lwn.net>
X-Echelon-Scan: plutonium bomb osama revenge dirty allah satan iran victory
 dimona cocaine guantanamo centrifuge holy war pigs mossad nsa
X-Echelon-Result: Belligerent
Organization: FAU Department of Computer Science IV
X-URL: http://www4.cs.fau.de/~arw/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-28T20:17, Jonathan Corbet <corbet@lwn.net> wrote:
> On Mon, 12 Jan 2015 00:58:06 +0100
> Julian Brost <linux-kernel@0x4a42.net> wrote:
> 
> > Make the heading underlines fit the length of the heading, remove colons
> > at the end of headings and consistently place an empty line after each
> > heading and two empty lines before each that is preceded by a paragraph.
> > 
> > Signed-off-by: Julian Brost <linux-kernel@0x4a42.net>
> > Signed-off-by: Fabian Hofmann <fabian.hofmann@fau.de>
> 
> [Finally catching up with stuff after a long travel]
> 
> These changes look fine, but what's with the two signoffs?  Who is the
> actual author of these patches, and why is the second signoff there?

I'm not an author of this patch, but I can explain that: Julian and
Fabian are students of mine and as part of classwork they are supposed
to submit a patch to the linux kernel. Since we require our students to
work in groups of two and to collaborate on producing and submitting the
patch, we also strongly urge them to submit with two signed-off-by-lines
to properly attribute the patch to both students.

I hope this doesn't cause any confusion or misbehaving tools or
anything.

If you are interested in further information on the course you can visit
https://www4.cs.fau.de/Lehre/WS14/P_PASST/ (unfortunately only in
german) or ask me by email. There is also a (not up-to-date for this
semester) list of previously accepted patches that were produced in
earlier iterations of this course:
https://www4.cs.fau.de/Lehre/WS14/P_PASST/kernel-commits-all.shtml


Greetings,

Alexander Wuerstlein.

----
Alexander Wuerstlein         Informatik 4            Univ. of Erlangen
Martensstrasse 1            91058 Erlangen           +49-9131-85-27824
arw@arw.name  arw@cs.fau.de   3CD3D074014E217A745FC4A34E2CCA53C746347D
snalwuer@cip.cs.fau.de                     https://www4.cs.fau.de/~arw
