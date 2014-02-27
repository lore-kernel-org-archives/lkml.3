Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaB0Sno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:43:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46636 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaB0Snn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:43:43 -0500
Message-ID: <530F87CC.8090000@oracle.com>
Date: Thu, 27 Feb 2014 13:45:32 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v2] xen: add support for MSI message groups
References: <530F68BE.2070505@oracle.com> <1393524935-4216-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1393524935-4216-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 01:15 PM, Roger Pau Monne wrote:
> Add support for MSI message groups for Xen Dom0 using the
> MAP_PIRQ_TYPE_MULTI_MSI pirq map type.
>
> In order to keep track of which pirq is the first one in the group all
> pirqs in the MSI group except for the first one have the newly
> introduced PIRQ_MSI_GROUP flag set. This prevents calling
> PHYSDEVOP_unmap_pirq on them, since the unmap must be done with the
> first pirq in the group.

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


