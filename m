Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965226Ab3DHWHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 18:07:43 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:59351 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762377Ab3DHWHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 18:07:42 -0400
Date: Mon, 8 Apr 2013 23:07:37 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org,
        jgarzik@redhat.com
Subject: Re: [PATCH] [libata] Fix HDIO_DRIVE_CMD ioctl sense data check
Message-ID: <20130408220737.GA6927@milliways>
References: <CAMHSBOVZ7w51+8B=LyNBdeqP2BEYaNMDX3_WbEzUYqjdn2FZFg@mail.gmail.com>
 <1364536609-17398-1-git-send-email-gwendal@google.com>
 <515CC01C.3070502@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <515CC01C.3070502@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=GaEGOwq9FwezmTggA+b6yC6zDZF2HYaK6RN/tSqdnVA= c=1 sm=0 a=wom5GMh1gUkA:10 a=7tItc54Vev4A:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=JohSteC94XCOTakJihUA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 07:49:48PM -0400, Jeff Garzik wrote:
> 
> applied the version from Krzysztof Mazur, which covered both cases
> 
> 
 According to linus's changelog for -rc6, this doesn't seem to have
been included ?

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
