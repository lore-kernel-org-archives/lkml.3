Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab3BKXrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:47:53 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:48746 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab3BKXrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:47:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAG=jzgDxD5ZB683bieoCHQFTehRmOMwnzgefmeSenRPFudY4RA@mail.gmail.com>
References: <CAG=jzgDxD5ZB683bieoCHQFTehRmOMwnzgefmeSenRPFudY4RA@mail.gmail.com>
Date: Mon, 11 Feb 2013 23:47:51 +0000
Message-ID: <CAG=jzgD6JQ1AiSy0e4iurydi5z9BAMmNqat=9P6xu+rBjYOVpQ@mail.gmail.com>
Subject: Fwd: Xonar DG pci sound card driver incomplete
From: kernel kernel <kernel@kenobrien.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requesting guidance on how to implement the missing mic input support
for this Asus Xonar card. I've downloaded the relevant datasheets but
am unsure how to proceed. I have physical access to this hardware. I
would appreciate a description of a workflow towards finishing this
driver or any other comments.

I believe the audio processor in question is the C-Media CMI8786 and
the existing driver is located in   sound/pci/oxygen.

Regards,

Ken

--
Ken O'Brien
PhD Researcher
Simulation Science and Extreme Events Cluster,
3B1, UCD CASL,
8 Belfield Business Park,
Dublin 4,
Ireland.
