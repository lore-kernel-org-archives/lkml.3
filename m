Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab3CLDoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:44:30 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:52723 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab3CLDo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:44:28 -0400
Date: Mon, 11 Mar 2013 23:44:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Dave Jones <davej@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: torrent hash failures since 3.9.0-rc1
Message-ID: <20130312034422.GC18595@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Dave Jones <davej@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
References: <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
 <20130311211833.GC15478@thunk.org>
 <20130311213837.GA438@x4>
 <20130311231227.GA319@x4>
 <20130312030057.GA6142@gmail.com>
 <20130312033054.GB18595@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312033054.GB18595@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:30:54PM -0400, Theodore Ts'o wrote:
> > As Ted suggested, could you please try to use ext4 git tree?  I want to
> > make sure whether this bug has been fixed by my lastest patch series or
> > not.
> 
> It's definitely worth a try to compile the master branch of the ext4
> tree and see if it reproduces or not.

Sorry, what you should try is the dev branch of the ext4 tree.  That
has the new patches that we are currently QA'ing for 3.9-rc3
(hopefully).

					- Ted
