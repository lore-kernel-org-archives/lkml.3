Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbbAGPIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:08:15 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:58159 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbbAGPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:08:14 -0500
Date: Wed, 7 Jan 2015 10:08:09 -0500
From: Tejun Heo <tj@kernel.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Remove FIXME comment in atapi_eh_request_sense
Message-ID: <20150107150809.GA4395@htj.dyndns.org>
References: <1420609492-19422-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420609492-19422-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 12:44:52AM -0500, Nicholas Krause wrote:
> Remove the FIXME comment in  atapi_eh_request_sense () asking whether
> memset of sense buffer is necessary.  The buffer may be partially or
> fully filled by the device.  We want it to be cleared.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Applied to libata/for-3.20.  Thanks.

-- 
tejun
