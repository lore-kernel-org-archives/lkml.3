Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbaDXRG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:06:29 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:50072 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915AbaDXRG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:06:27 -0400
Message-ID: <53594490.7040205@cogentembedded.com>
Date: Thu, 24 Apr 2014 21:06:24 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v7 20/20] usb: phy: msm: Use usb_add_phy_dev() to register
 device
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com> <1398354495-20782-21-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1398354495-20782-21-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04/24/2014 07:48 PM, Ivan T. Ivanov wrote:

> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

> They could be more than one USB2.0 PHY's on the platform.

    s/They/There/

> This will allow all of them to be registred successfuly.

    s/registred successfuly/registered successfully/

> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

WBR, Sergei

