Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaABSoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:44:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43265 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaABSoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:44:12 -0500
Message-ID: <52C5B266.1090009@zytor.com>
Date: Thu, 02 Jan 2014 10:39:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
Subject: Re: [PATCH v12] Linux Xen PVH support.
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2013 08:35 PM, Konrad Rzeszutek Wilk wrote:
> The patches, also available at
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pvh.v12
> 
> implements the neccessary functionality to boot a PV guest in PVH mode.
> 

As x86 maintainer I would like to see a list of what pvops are necessary
in PVH mode.  Obviously the hope is that the really invasive ones will
not be necessary (and there are good reasons to believe that is within
reach.)

	-hpa


