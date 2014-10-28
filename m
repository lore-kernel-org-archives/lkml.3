Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaJ1Mrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:47:39 -0400
Received: from tex.lwn.net ([70.33.254.29]:43176 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbaJ1Mri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:47:38 -0400
Date: Tue, 28 Oct 2014 08:47:35 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Peter Foley <pefoley2@pefoley.com>
Cc: Alexander Graf <agraf@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        afaerber@suse.de
Subject: Re: [PATCH] Documentation: Restrict TSC test code to x86
Message-ID: <20141028084735.6338d01b@lwn.net>
In-Reply-To: <CAOFdcFOChK9Jdw9mQGL7Zdc=89GU4hmuPE=Mn_vvWJFDYEtQBw@mail.gmail.com>
References: <1414454639-7491-1-git-send-email-agraf@suse.de>
	<CAOFdcFOChK9Jdw9mQGL7Zdc=89GU4hmuPE=Mn_vvWJFDYEtQBw@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014 20:07:51 -0400
Peter Foley <pefoley2@pefoley.com> wrote:

> > The prctl test code in Documentation/ tries to show how to
> > use a call that only makes sense on x86. Restrict it there
> > so that other platforms don't try to call asm("rdtsc").
> >
> > Signed-off-by: Alexander Graf <agraf@suse.de>  
> 
> Acked-by: Peter Foley <pefoley2@pefoley.com>

Snagged into the docs tree, thanks.

jon
