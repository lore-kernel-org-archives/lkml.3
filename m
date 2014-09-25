Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaIYQ7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:59:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:48781 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaIYQ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:59:23 -0400
Date: Thu, 25 Sep 2014 19:01:47 +0200
From: Christoph Hellwig <hch@infradead.org>
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: hch@infradead.org, bruce.lucas@mongodb.com, adam.radford@avagotech.com,
        kashyap.desai@avagotech.com,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mptfusion: enable no_write_same for vmware scsi disks
Message-ID: <20140925170147.GB17892@infradead.org>
References: <20140923071154.GB3867@infradead.org>
 <1411482160-32007-1-git-send-email-chris.j.arges@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411482160-32007-1-git-send-email-chris.j.arges@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied to drivers-for-3.18 with Cc to stable.
