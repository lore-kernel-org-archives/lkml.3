Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaHZQxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:53:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52407 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaHZQxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:53:37 -0400
Message-ID: <53FCBB8F.1040401@wwwdotorg.org>
Date: Tue, 26 Aug 2014 10:53:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/6] resource: Add device-managed request/release_resource()
References: <1409065898-26887-1-git-send-email-thierry.reding@gmail.com> <1409065898-26887-2-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1409065898-26887-2-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 09:11 AM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> Provide device-managed implementations of the request_resource() and
> release_resource() functions. Upon failure to request a resource, the
> new devm_request_resource() function will output an error message for
> consistent error reporting.

The series,
Tested-by: Stephen Warren <swarren@nvidia.com>
