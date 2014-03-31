Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaCaRtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:49:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54756 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329AbaCaRtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:49:50 -0400
Message-Id: <1396288189.17715.101062725.0503948F@webmail.messagingengine.com>
X-Sasl-Enc: FkdtXgVf9BPeysUn+GsPAAY4s69QDTIPmtCEnfG07tvH 1396288189
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Shuduo Sang <shuduo.sang@canonical.com>, matthew.garrett@nebula.com,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bruce.ma@canonical.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-8832fc58
In-Reply-To: <531EECF9.1040600@canonical.com>
References: <531EECF9.1040600@canonical.com>
Subject: Re: [PATCH V4 RESEND] Support Thinkpad X1 Carbon 2nd gen's adaptive
 keyboard
Date: Mon, 31 Mar 2014 14:49:49 -0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014, at 8:01, Shuduo Sang wrote:
> Resend patch V4. Support Thinkpad X1 Carbon 2nd generation's adaptive
> keyboard.
> 
> Hi Henrique, could you please have a chance to review it?

I am unable to do a full review right now, but we can always adjust
minor details of the feature with later patches and the previous reviews
did help clean up the feature.

However: as far as I am concerned, this is an experimental feature until
it matures for a while.  I'd rather we plug this somehow to the
thinkpad-acpi input map, for example.

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
