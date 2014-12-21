Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaLUWfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 17:35:07 -0500
Received: from plane.gmane.org ([80.91.229.3]:34311 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaLUWfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 17:35:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Eliot Blennerhassett <eliot@blennerhassett.gen.nz>
Subject: Re: [PATCH] sound: pci: asihpi: hpifunc.c:  Remove some unused functions
Date: Mon, 22 Dec 2014 11:32:06 +1300
Message-ID: <54974A66.8010209@blennerhassett.gen.nz>
References: <1419180627-8986-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 121-72-250-62.cable.telstraclear.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
In-Reply-To: <1419180627-8986-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Cc: alsa-devel@alsa-project.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/12/14 05:50, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:

NAK - because  hpi_adapter_set_property() is now used in for-next branch
of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git

Otherwise I have no problem with the patch.

