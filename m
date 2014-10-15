Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaJOXc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:32:59 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50769 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaJOXc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <CA+QbAV40LRnqghVzpUy4MqbjP2+tfsXWcBfot+TA2S+F5wsvng@mail.gmail.com>
References: <CA+QbAV40LRnqghVzpUy4MqbjP2+tfsXWcBfot+TA2S+F5wsvng@mail.gmail.com>
Date: Wed, 15 Oct 2014 16:32:57 -0700
Message-ID: <CA+QbAV44doidDEw20eojiZsmCHfeiR4eioy_+X5B6E8nQHh6_A@mail.gmail.com>
Subject: Re: PCIe PASID (Process Address Space ID) and iommu code
From: Kallol Biswas <nucleodyne@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    PCIe has introduced PASID TLP Prefix.  There are two ECNs on this.

It seems that AMD iommu code makes use of PASID. Is there a device that
utilizes this TLP prefix?

PASID allocation and management within a device is not clear to me. How
does device know which PASID to issue for with virtual address? Who makes
the association? Must be software/OS, but how? There is no table for this
like MSI-X table.

Any pointer/documentation will be appreciated.

Regards,
