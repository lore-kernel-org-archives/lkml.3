Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaKDKMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:12:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbaKDKMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:12:07 -0500
Date: Tue, 4 Nov 2014 11:12:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] HID: logitech-hidpp: 2 fixes in
 hidpp_root_get_protocol_version()
In-Reply-To: <1415048999-4490-2-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1411041111580.19451@pobox.suse.cz>
References: <1415048999-4490-1-git-send-email-benjamin.tissoires@redhat.com> <1415048999-4490-2-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, Benjamin Tissoires wrote:

> - remove the constant '1'
> - when the device is not connected, the protocol error
>   HIDPP_ERROR_RESOURCE_ERROR is raised. We should not warn the user about
>   it because it is somewhat expected as an answer when we check if the
>   device is connected.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Changes in v2:
>  none

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
