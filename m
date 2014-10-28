Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaJ1NMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:12:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaJ1NMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:12:44 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] Documentation: Restrict TSC test code to x86
From: Alexander Graf <agraf@suse.de>
X-Mailer: iPhone Mail (12B411)
In-Reply-To: <20141028084735.6338d01b@lwn.net>
Date: Tue, 28 Oct 2014 14:12:43 +0100
Cc: Peter Foley <pefoley2@pefoley.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        "afaerber@suse.de" <afaerber@suse.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <CF6E40FB-3CB1-43BD-8691-46AD21DA62A0@suse.de>
References: <1414454639-7491-1-git-send-email-agraf@suse.de> <CAOFdcFOChK9Jdw9mQGL7Zdc=89GU4hmuPE=Mn_vvWJFDYEtQBw@mail.gmail.com> <20141028084735.6338d01b@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> Am 28.10.2014 um 13:47 schrieb Jonathan Corbet <corbet@lwn.net>:
> 
> On Mon, 27 Oct 2014 20:07:51 -0400
> Peter Foley <pefoley2@pefoley.com> wrote:
> 
>>> The prctl test code in Documentation/ tries to show how to
>>> use a call that only makes sense on x86. Restrict it there
>>> so that other platforms don't try to call asm("rdtsc").
>>> 
>>> Signed-off-by: Alexander Graf <agraf@suse.de>  
>> 
>> Acked-by: Peter Foley <pefoley2@pefoley.com>
> 
> Snagged into the docs tree, thanks.

Awesome, please make sure this makes it into 3.18 - the build is broken on non-x86 archs there ;).

Alex

