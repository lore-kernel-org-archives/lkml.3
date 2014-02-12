Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaBLTVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:21:12 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35471 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbaBLTVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:21:09 -0500
Message-Id: <1392232868.5899.82643845.5A0B5EBE@webmail.messagingengine.com>
X-Sasl-Enc: KG/Zxev8hE71WHMozRhkE4hBHAR+IDW2cdCBBTRr+M1Y 1392232868
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-e72899be
Subject: Re: [PATCH] thinkpad_acpi: Fix inconsistent mute LED after resume
Date: Wed, 12 Feb 2014 17:21:08 -0200
In-Reply-To: <1392219165-20888-1-git-send-email-tiwai@suse.de>
References: <1392219165-20888-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014, at 13:32, Takashi Iwai wrote:
> The mute LED states have to be restored after resume.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=70351
> Cc: <stable@vger.kernel.org> [v3.13+]
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
