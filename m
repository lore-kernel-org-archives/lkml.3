Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909Ab3EWWrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 18:47:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58303 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759888Ab3EWWq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 18:46:59 -0400
Message-ID: <519E9C4C.3080305@zytor.com>
Date: Thu, 23 May 2013 15:46:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/PCI: setup data may be in highmem
References: <1369215782-32697-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1369215782-32697-1-git-send-email-matt@console-pimps.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 02:43 AM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> pcibios_add_device() assumes that the physical addresses stored in
> setup_data are accessible via the direct kernel mapping, and that
> calling phys_to_virt() is valid. This isn't guaranteed to be true on x86
> where the direct mapping range is much smaller than on x86-64.
> 
> Calling phys_to_virt() on a highmem address results in the following,
> 

Bjorn: yours or mine?

	-hpa


