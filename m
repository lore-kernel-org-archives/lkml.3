Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3LLTed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:34:33 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43499 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab3LLTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:34:32 -0500
Message-ID: <52AA0FC4.3090606@vmware.com>
Date: Thu, 12 Dec 2013 20:34:28 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFC] dma-buf: Implement test module
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1386858989-1487-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 03:36 PM, Thierry Reding wrote:
> This is a simple test module that can be used to allocate, export and
> delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
> systems that lack a real second driver.
>
>

Looks nice. I wonder whether this could be extended to create a 
"streaming" dma-buf from a user space mapping. That could be used as a 
generic way to implement streaming (user) buffer objects, rather than to 
add explicit support for those in, for example, TTM.

/Thomas
