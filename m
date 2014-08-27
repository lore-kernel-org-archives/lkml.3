Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936008AbaH0VGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:06:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935336AbaH0VG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:06:27 -0400
Date: Wed, 27 Aug 2014 23:06:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: logitech-dj: break out testing of validity of
 dj_device
In-Reply-To: <1408738566-6805-2-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1408272305560.21233@pobox.suse.cz>
References: <1408738566-6805-1-git-send-email-benjamin.tissoires@redhat.com> <1408738566-6805-2-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Benjamin Tissoires wrote:

> We can do once the test of the validity of the dj_device, which removes
> some duplicated code in various functions.

Queued for 3.18, thanks Benjamin.

-- 
Jiri Kosina
SUSE Labs
