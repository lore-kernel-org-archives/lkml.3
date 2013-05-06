Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3EFOYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:24:53 -0400
Received: from canardo.mork.no ([148.122.252.1]:47487 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab3EFOYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:24:52 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Patrick Monnerat" <Patrick.Monnerat@datasphere.ch>
Cc: "Neela Syam Kolli" <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Create megaraid ioctl device node
Organization: m
References: <AB5E58B87EB73C46A38073D8F459F113D9FBA4@dataspheresrv01>
Date: Mon, 06 May 2013 16:23:44 +0200
In-Reply-To: <AB5E58B87EB73C46A38073D8F459F113D9FBA4@dataspheresrv01> (Patrick
	Monnerat's message of "Mon, 6 May 2013 15:58:31 +0200")
Message-ID: <87a9o86vbj.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Patrick Monnerat" <Patrick.Monnerat@datasphere.ch> writes:

> From: Patrick Monnerat <pm@datasphere.ch>
>
>   Create ioctl device node for megaraid_sas driver. Let this node be
> managed by udev. Fix a typo.

Or maybe just simplify it all and use a misc device instead?  See how
this is done in e.g. drivers/scsi/mpt3sas/mpt3sas_ctl.c or
drivers/message/fusion/mptctl.c



Bjørn
