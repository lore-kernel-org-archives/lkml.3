Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaCMCJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 22:09:35 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:39637 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaCMCJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 22:09:33 -0400
X-Auth-Info: UzsigNYQ/N2DM4YwRqGyrZt4oWouobxrdzncL6Du0sI=
From: Marek Vasut <marex@denx.de>
To: Matt Ranostay <mranostay@gmail.com>
Subject: Re: [PATCH v8 2/2] iio: Add AS3935 lightning sensor support
Date: Thu, 13 Mar 2014 03:09:32 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, matt.porter@linaro.org,
        pantelis.antoniou@gmail.com
References: <1394628794-7598-1-git-send-email-mranostay@gmail.com> <1394628794-7598-3-git-send-email-mranostay@gmail.com>
In-Reply-To: <1394628794-7598-3-git-send-email-mranostay@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201403130309.32474.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 12, 2014 at 01:53:14 PM, Matt Ranostay wrote:
> AS3935 chipset can detect lightning strikes and reports those back as
> events and the estimated distance to the storm.
> 
> Signed-off-by: Matt Ranostay <mranostay@gmail.com>

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
