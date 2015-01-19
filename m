Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbbASJw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:52:57 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39183 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbbASJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:52:55 -0500
Date: Mon, 19 Jan 2015 01:52:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [PATCH v4] virtio-scsi: Fix the race condition in
 virtscsi_handle_event
Message-ID: <20150119095254.GA7333@infradead.org>
References: <1420685852-5078-1-git-send-email-famz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420685852-5078-1-git-send-email-famz@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

are you fine with this version?
