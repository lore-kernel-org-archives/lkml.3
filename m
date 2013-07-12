Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab3GLRVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:21:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36993 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650Ab3GLRVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:21:07 -0400
Message-ID: <51E03AEE.5010403@zytor.com>
Date: Fri, 12 Jul 2013 10:20:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org> <20130712025745.GA24086@tuxdriver.com> <20130712033430.GA3798@kroah.com>
In-Reply-To: <20130712033430.GA3798@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the subject of the stable tree: could we get a standard format for
requesting post-inclusion elevation of patches to stable status?  It
isn't all that unusual that the need for -stable is highlighted after a
patch has been included in a maintainer's tree, and rebasing to add
stable metadata annoys Linus.

	-hpa

