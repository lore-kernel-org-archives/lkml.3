Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaEMTTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:19:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37106 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbaEMTSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:18:55 -0400
Date: Tue, 13 May 2014 21:18:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: rmi: fix duplicated argument to && or ||
In-Reply-To: <1400008501-7165-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1405132118200.16459@pobox.suse.cz>
References: <1400008501-7165-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Benjamin Tissoires wrote:

> This resulted from an unfortunate copy/paste.
> 
> Detected automagically by kbuild.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

I have already fixed this in the tree after seeing Dan's email.

Thanks, good catch!

-- 
Jiri Kosina
SUSE Labs
