Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab3LWRqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:46:48 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:34574 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab3LWRqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:46:45 -0500
Date: Mon, 23 Dec 2013 10:46:34 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org, patches@apm.com,
        linux-kernel@vger.kernel.org, jcm@redhat.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/3] arm64: dts: APM X-Gene PCIe device tree nodes
Message-ID: <20131223174634.GD25089@obsidianresearch.com>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
 <1387785725-24262-3-git-send-email-tinamdar@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387785725-24262-3-git-send-email-tinamdar@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 01:32:03PM +0530, Tanmay Inamdar wrote:
> This patch adds the device tree nodes for APM X-Gene PCIe controller and
> PCIe clock interface. Since X-Gene SOC supports maximum 5 ports, 5 dts nodes
> are added.

Can you include an lspci dump for PCI DT bindings please? It is
impossible to review otherwise..

Regards,
Jason
