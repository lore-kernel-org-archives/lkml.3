Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbaFJJHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:07:31 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:53621 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaFJJHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:07:30 -0400
X-IronPort-AV: E=Sophos;i="4.98,1008,1392163200"; 
   d="scan'208";a="141493014"
Message-ID: <5396CACF.6050801@citrix.com>
Date: Tue, 10 Jun 2014 10:07:27 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>
Subject: Re: [PATCH 3.4 82/88] xen/setup: Populate freed MFNs from non-RAM
 E820 entries and gaps to E820 RAM
References: <20140610002424.500996570@linuxfoundation.org> <20140610002427.192691272@linuxfoundation.org>
In-Reply-To: <20140610002427.192691272@linuxfoundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/14 01:25, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.

This is a new feature and not a bug fix.  I don't think it (and patches
83-85) are suitable for stable.

David
