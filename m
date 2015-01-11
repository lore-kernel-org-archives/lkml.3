Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbbAKQzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:55:07 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:57093 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbbAKQzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:55:05 -0500
Date: Sun, 11 Jan 2015 11:55:01 -0500
From: Tejun Heo <tj@kernel.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: libata-core: Remove unused function
Message-ID: <20150111165501.GG25319@htj.dyndns.org>
References: <1420986421-18686-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420986421-18686-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 03:27:01PM +0100, Rickard Strandqvist wrote:
> Remove the function ata_do_simple_cmd() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied to libata/for-3.20.  Thanks.

-- 
tejun
