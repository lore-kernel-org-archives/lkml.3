Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab3B0PlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:41:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43520 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760051Ab3B0PlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:41:07 -0500
Date: Wed, 27 Feb 2013 16:40:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: nohz splat
Message-ID: <20130227154058.GE5530@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <20130220210210.GA1395@pd.tnic>
 <CAFTL4hyeQdMOKEvswEtM69gTg1zhnh8fK4QH_2CGC6vNcO2V7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFTL4hyeQdMOKEvswEtM69gTg1zhnh8fK4QH_2CGC6vNcO2V7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 04:37:16PM +0100, Frederic Weisbecker wrote:
> This is some debugging code I added to chase stale runqueue clocks. I
> have the feeling that debugging code is buggy though. I need to check
> that.

Ok, cool. Let me know when I should retest again.

Thanks.

> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
