Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbbA0Qnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:43:51 -0500
Received: from netrider.rowland.org ([192.131.102.5]:57467 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755187AbbA0Qns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:43:48 -0500
Date: Tue, 27 Jan 2015 11:43:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
cc: gregkh@linuxfoundation.org, <lars@metafoo.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH_V2 0/3] usb: ohci: jz4740: Add DT support and a fix
In-Reply-To: <1422367356-38012-1-git-send-email-Zubair.Kakakhel@imgtec.com>
Message-ID: <Pine.LNX.4.44L0.1501271143220.28374-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Zubair Lutfullah Kakakhel wrote:

> Hi,
> 
> Here are a few simple patches for the jz4740.
> 
> First adds a simple DT binding.
> Seconds adds DT support.
> Third is a minor fix in clock enabling.
> 
> Patches are based on 3.19-rc6. Quite disjoint and stay within jz4740 
> so should apply easily on other trees.
> 
> If you would like to have them rebased to a different tree, please tell.

Patches 2/3 and 3/3:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

