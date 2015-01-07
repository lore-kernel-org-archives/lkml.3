Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbbAGU6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:58:07 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:37607 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbbAGU6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:58:05 -0500
Message-ID: <54AD9DD8.2080008@cogentembedded.com>
Date: Wed, 07 Jan 2015 23:58:00 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
CC: Alex Williamson <alex.williamson@redhat.com>,
        Greg Kurz <gkurz@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/net: length miscalculation
References: <1420620847-24477-1-git-send-email-mst@redhat.com>
In-Reply-To: <1420620847-24477-1-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/07/2015 11:55 AM, Michael S. Tsirkin wrote:

> commit 8b38694a2dc8b18374310df50174f1e4376d6824
>      vhost/net: virtio 1.0 byte swap
> had this chunk:
> -       heads[headcount - 1].len += datalen;
> +       heads[headcount - 1].len = cpu_to_vhost32(vq, len - datalen);

> This adds datalen with the wrong sign, causing guest panics.

> Fixes: 8b38694a2dc8b18374310df50174f1e4376d6824

    The format of this tag assumes 12-digit SHA1 hash and the commit 
description enclosed in parens and double quotes. See 
Documentation/SubmittingPatches.

> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Suggested-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

WBR, Sergei

