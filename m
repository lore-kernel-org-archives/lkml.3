Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaAJWtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 17:49:36 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.179]:34125 "EHLO
	mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaAJWte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 17:49:34 -0500
X-RZG-CLASS-ID: mo04
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ4Kkzc/qnW2/7iWQ==
Date: Fri, 10 Jan 2014 23:49:27 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: david.vrabel@citrix.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen-blkfront: remove type check from
 blkfront_setup_discard
Message-ID: <20140110224927.GA14824@aepfle.de>
References: <1389371301-29532-1-git-send-email-olaf@aepfle.de>
 <52D036FC.6000308@oracle.com>
 <20140110213746.GA933@aepfle.de>
 <52D073F0.5020400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D073F0.5020400@oracle.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, Boris Ostrovsky wrote:

> I think we should at clear feature_discard and print an error in the log if
> *either* of xenbus_gather() calls fail.

Are you sure about that? AFAIK many other properties are optional as
well. I dont think there is a formal spec about the discard related
properties. Should every backend be required to provide all four
properties? 

Olaf
