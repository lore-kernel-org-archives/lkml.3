Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaATPbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:31:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33613 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaATPbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:31:09 -0500
Date: Mon, 20 Jan 2014 15:31:05 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Souvik Banerjee <souvik1997@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-wmi: Add KEY_SWITCHVIDEOMODE for Dell N4110.
Message-ID: <20140120153105.GA1650@srcf.ucam.org>
References: <52DD4096.6020408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DD4096.6020408@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 09:28:22AM -0600, Souvik Banerjee wrote:
> This key is reported by the keyboard controller but also generates WMI
> events. By adding it to the legacy keymap the WMI messages can be
> silenced.

Wouldn't this result in it being reported twice?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
