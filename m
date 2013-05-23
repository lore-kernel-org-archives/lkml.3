Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab3EWOZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:25:43 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57474 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab3EWOZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:25:42 -0400
Message-ID: <519E26E9.3040301@cogentembedded.com>
Date: Thu, 23 May 2013 18:25:45 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ravi Babu <ravibabu@ti.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH v1 7/9] usb: musb: dsps: use get-usb-phy by phandle for
 multi instance
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com> <1369288888-8614-8-git-send-email-ravibabu@ti.com>
In-Reply-To: <1369288888-8614-8-git-send-email-ravibabu@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-05-2013 10:01, Ravi Babu wrote:

> In case of mutli instance support, use get-phy object using phandle
> to return to repsective phy xceiv object for each instance

    Only "respective" and s/xceiv/transceiver/.

> Signed-off-by: Ravi Babu <ravibabu@ti.com>

WBR, Sergei

