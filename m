Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3C2Xa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 19:30:26 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:30628 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757244Ab3C2XaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 19:30:25 -0400
Date: Fri, 29 Mar 2013 23:30:20 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Gwendal Grignou <gwendal@google.com>
Cc: linux-kernel@vger.kernel.org, jgarzik@redhat.com
Subject: Re: [PATCH] [libata] Fix HDIO_DRIVE_CMD ioctl sense data check
Message-ID: <20130329233020.GA1866@milliways>
References: <CAMHSBOVZ7w51+8B=LyNBdeqP2BEYaNMDX3_WbEzUYqjdn2FZFg@mail.gmail.com>
 <1364536609-17398-1-git-send-email-gwendal@google.com>
 <20130329183103.GA27693@milliways>
 <20130329203443.GA30494@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130329203443.GA30494@milliways>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=GaEGOwq9FwezmTggA+b6yC6zDZF2HYaK6RN/tSqdnVA= c=1 sm=0 a=wom5GMh1gUkA:10 a=7tItc54Vev4A:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=8vHXcPWz_IX1yI0MvE0A:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 08:34:43PM +0000, Ken Moffat wrote:
> On Fri, Mar 29, 2013 at 06:31:03PM +0000, Ken Moffat wrote:

>  I've no idea about the details, but it looks to me as if smartd is
> still getting different values returned to it.  The capability check
> normally was ok (silent), the automatic testing normally showed as
> 'enabled'd.
> 
 After that I found today's posts in Krzystof Mazur's earlier
thread.  When I first read that I thought it was for a specific
drive, and didn't remember it when I had time to try rc4.

 The v2 of the patch (with two hunks) fixes it for me too.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
