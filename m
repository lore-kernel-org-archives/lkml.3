Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbbADRw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 12:52:28 -0500
Received: from muffat.debian.org ([206.12.19.146]:55659 "EHLO
	muffat.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbbADRwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 12:52:25 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2015 12:52:25 EST
Date: Sun, 4 Jan 2015 18:45:51 +0100
From: Guillem Jover <guillem@debian.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: libaio tarballs on <kernel.org>
Message-ID: <20150104174551.GA25496@gaara.hadrons.org>
Mail-Followup-To: Guillem Jover <guillem@debian.org>,
	Sedat Dilek <sedat.dilek@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <CA+icZUUkp4OrPWfw7PEpt2DDEyrf+z1SAQcXpREOXoA7JQ0stg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUUkp4OrPWfw7PEpt2DDEyrf+z1SAQcXpREOXoA7JQ0stg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Thu, 2015-01-01 at 22:23:44 +0100, Sedat Dilek wrote:
> I am playing with fio (manually compiled v2.2.3) and wanted to update
> also my libaio development package on Ubuntu/precise.

I'm not aware of any version later than the one in Debian. And git only
seems to contain a single commit over 0.3.110?

> Both dsc (description) files of Debian and Ubuntu libaio source
> packages v0.3.110 [1,2] point to a URL on <kernel.org> [3].
> This space is empty.

Right, if they are not coming back to kernel.org I should probably
change those URLs in the Debian package.

> My question: Where does someone get official libaio tarballs?

I get them (as mentioned in the debian/watch file) from
<http://pkgs.fedoraproject.org/repo/pkgs/libaio/>.

Thanks,
Guillem
