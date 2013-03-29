Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3C2TCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:02:13 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:36230 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab3C2TCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:02:11 -0400
Message-ID: <5155F320.2020004@cogentembedded.com>
Date: Fri, 29 Mar 2013 23:01:36 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Gwendal Grignou <gwendal@google.com>
CC: ronald645@gmail.com, krzysiek@podlesie.net, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [libata] Fix HDIO_DRIVE_CMD ioctl sense data check
References: <1364576992-17598-1-git-send-email-gwendal@google.com> <1364577166-17930-1-git-send-email-gwendal@google.com>
In-Reply-To: <1364577166-17930-1-git-send-email-gwendal@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/29/2013 08:12 PM, Gwendal Grignou wrote:

> commit 84a9a8cd9d0aa93c17e5815ab8a9cc4c0a765c63

    Please, also specify that commit's summary line in parens
(or however you like).

>   changed the sense key
> used for returning task registers, but HDIO_DRIVE_CMD ioctl was
> not changed accordingly.
>
> Tested: check that SMART ENABLE sent using HDIO_DRIVE_CMD returns 0
> instead of EIO.
>
> Signed-off-by: Gwendal Grignou <gwendal@google.com>
>

MBR, Sergei

