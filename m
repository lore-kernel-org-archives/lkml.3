Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083Ab3IZPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:16:58 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33600 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3IZPQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:16:57 -0400
Date: Thu, 26 Sep 2013 11:16:49 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] pci: remove redundant pci_dev_get/put() on
 kobject (un)register
Message-ID: <20130926151649.GD12301@hmsreliant.think-freely.org>
References: <1380204675-18238-1-git-send-email-vfalico@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380204675-18238-1-git-send-email-vfalico@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 04:11:13PM +0200, Veaceslav Falico wrote:
> Currently we're pci_dev_get/put()-ing pci device on every kobject
> creation/removal. It's useless per se - the kobject is part of the device
> itself, so it should be removed when there are no users of the pdev, and is
> not a user of it.
> 
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: linux-pci@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

