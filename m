Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaCRLaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:30:22 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:44108 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbaCRLaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140317235240.GA14292@google.com>
References: <CAGG0vUg+No2GHLbOLQzV+fNm37OW-pfhmoQ3moxhr8uEObj9pQ@mail.gmail.com>
	<20140317235240.GA14292@google.com>
Date: Tue, 18 Mar 2014 13:30:20 +0200
Message-ID: <CAGG0vUi0Rpm3h6KMgnqTyAPQGr3Qgk9iNnDC7kAHaU--Qfnucg@mail.gmail.com>
Subject: Re: [bisected] e501 "agp: Support 64-bit APBASE" agp fails without iommu=remap=2
From: =?UTF-8?B?Sm91bmkgTWV0dMOkbMOk?= <jtmettala@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Yinghai Lu <yinghai@kernel.org>, Guo Chao <yan@linux.vnet.ibm.com>,
        David Airlie <airlied@linux.ie>, Aaron Durbin <adurbin@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-18 1:52 GMT+02:00 Bjorn Helgaas <bhelgaas@google.com>:
>


>
> Jouni, could you try the patch below?
>
> Bjorn
>

>
> Revert "[PATCH] Insert GART region into resource map"
>

Works for me. dmesg attached to:
https://bugzilla.kernel.org/show_bug.cgi?id=72201
