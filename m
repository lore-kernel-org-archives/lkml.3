Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaI3Pue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:50:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaI3Pud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:50:33 -0400
Date: Tue, 30 Sep 2014 08:50:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nicolas Pitre <nico@linaro.org>
Cc: linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: aesbs-core.S_shipped?
Message-ID: <20140930155033.GA21640@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ard,

can you explain me why arch/arm/crypto/aesbs-core.S_shipped
is a _shipped file? I can't find any reason why it should be,
it's a normal .S file in every way as far as I can tell.
