Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaJ1RnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:43:22 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:33919 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaJ1RnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:43:20 -0400
Message-ID: <544FD5B1.9090407@cogentembedded.com>
Date: Tue, 28 Oct 2014 20:43:13 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, Peter.Chen@freescale.com, kishon@ti.com,
        stern@rowland.harvard.edu
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 6/7] usb: chipidea: move usb_otg into struct ci_hdrc
References: <1414514141-31767-1-git-send-email-antoine.tenart@free-electrons.com> <1414514141-31767-7-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1414514141-31767-7-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/28/2014 07:35 PM, Antoine Tenart wrote:

> Move the usb_otg member from struct usb_phy to struct ci_hdrc. Rework

    You're not reallky touching 'struct usb_phy'. ;-)

> its initialization taking in account this modification.

> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> Acked-by: Peter Chen <peter.chen@freescale.com>

WBR, Sergei


