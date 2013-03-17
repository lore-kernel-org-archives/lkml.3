Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3CQQic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 12:38:32 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:56813 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3CQQib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 12:38:31 -0400
Message-ID: <5145F17D.6050501@gmail.com>
Date: Sun, 17 Mar 2013 20:38:21 +0400
From: Lijo Antony <lijo.kernel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: airlied@linux.ie, bskeggs@redhat.com
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lijo.kernel@gmail.com
Subject: Re: [3.9.0-rc2] nouveau deadlock when HDMI TV is connected
References: <5144BA1E.7000203@gmail.com>
In-Reply-To: <5144BA1E.7000203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2013 10:29 PM, Lijo Antony wrote:
>
> But looking at 65b5f42e2a9eb9c8383fb67698bf8c27657f8c14, it looks I
> might have done some mistake in bisecting.

My bisecting was indeed incorrect. Issue started even before 3.9.0-rc1.
Attempting a proper bisect this time...

-lijo

