Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965578AbaGPRCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:02:15 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:45044 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934338AbaGPRCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:02:12 -0400
Message-ID: <53C6B014.4030602@cogentembedded.com>
Date: Wed, 16 Jul 2014 21:02:12 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: balbi@ti.com
CC: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        gregkh@linuxfoundation.org, Peter.Chen@freescale.com, kishon@ti.com,
        stern@rowland.harvard.edu, yoshihiro.shimoda.uh@renesas.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] usb: rename phy to usb_phy in HCD
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com> <1405435156-27297-5-git-send-email-antoine.tenart@free-electrons.com> <53C54F07.4050808@cogentembedded.com> <20140716150932.GF1365@saruman.home>
In-Reply-To: <20140716150932.GF1365@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/16/2014 07:09 PM, Felipe Balbi wrote:

>>> The USB PHY member of the HCD structure is renamed to 'usb_phy' and
>>> modifications are done in all drivers accessing it.

>>> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>

>>     I've been thru that and such change has been turned down already.

    OK, maybe not strictly "turned down" but still...

> can you find a link to that thread by any chance ?

    http://marc.info/?l=linux-sh&m=139706087101917

WBR, Sergei

