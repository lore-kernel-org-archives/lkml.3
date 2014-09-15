Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaIOSrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:47:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaIOSrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:47:45 -0400
Date: Mon, 15 Sep 2014 11:47:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-usb <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: review-ping: Re: [PATCH] scsi: fix regression that accidentally
 disabled block-based tcq
Message-ID: <20140915184745.GA25114@infradead.org>
References: <20140909152730.GA17882@infradead.org>
 <540FFBF4.9090001@redhat.com>
 <20140910154535.GA5102@infradead.org>
 <541172E9.8070309@redhat.com>
 <20140911161331.GA24488@infradead.org>
 <54134E50.6040805@redhat.com>
 <20140912230032.GA21143@infradead.org>
 <54141C59.7040707@redhat.com>
 <20140913175047.GA28882@infradead.org>
 <541562D4.90801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541562D4.90801@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can I get some reviews for this patch so that we can get into 3.17-rc?

