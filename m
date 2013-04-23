Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3DWVaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:30:05 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:61268 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3DWVaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:30:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAMix8LHNNFpz42BONnXu86Mvxx-h3FWb9_AOqGLS1NE8LSGt3g@mail.gmail.com>
References: <CAMix8LGzh1Sr-s=m4eQcRMYSDTuC=g2ddDwPbGcRvrnU3EYP5Q@mail.gmail.com>
	<CAMix8LHNNFpz42BONnXu86Mvxx-h3FWb9_AOqGLS1NE8LSGt3g@mail.gmail.com>
Date: Tue, 23 Apr 2013 23:30:03 +0200
Message-ID: <CAMix8LG-8ZkVtjVt1SsAJ1L9+YPhjGORvbw5nSdPfk-vrR0MgQ@mail.gmail.com>
Subject: Re: ehci-pci failed handover
From: =?UTF-8?Q?Jes=C3=BAs_J=2E_Guerrero_Botella?= 
	<jesus.guerrero.botella@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just used the old good method of including everything under the usb
drivers set as 'm', and it works now.

Sorry for the noise. I guess I wasn't including some relevant driver
for this concrete usb chip. Amazingly, the pendrives worked from the
first moment without any problem at all... go figure.

--
Jesús Guerrero Botella
