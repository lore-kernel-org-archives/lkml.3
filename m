Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaGOPzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:55:54 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:55318 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaGOPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:55:49 -0400
Message-ID: <53C54F07.4050808@cogentembedded.com>
Date: Tue, 15 Jul 2014 19:55:51 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu
CC: yoshihiro.shimoda.uh@renesas.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] usb: rename phy to usb_phy in HCD
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com> <1405435156-27297-5-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1405435156-27297-5-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/15/2014 06:39 PM, Antoine Ténart wrote:

> The USB PHY member of the HCD structure is renamed to 'usb_phy' and
> modifications are done in all drivers accessing it.

> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>

    I've been thru that and such change has been turned down already.

WBR, Sergei

