Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaJMRy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:54:57 -0400
Received: from wp038.webpack.hosteurope.de ([80.237.132.45]:56640 "EHLO
	wp038.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453AbaJMRy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:54:56 -0400
Date: Mon, 13 Oct 2014 19:54:51 +0200
From: Henning Schild <henning@hennsch.de>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH] drm/radeon: remove code that can never get executed
Message-ID: <20141013195451.52b0fcd8@hennsch.de>
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D05993B523@satlexdag05.amd.com>
References: <1413031067-26961-1-git-send-email-henning@hennsch.de>
	<1413031875-28053-1-git-send-email-henning@hennsch.de>
	<A3397C8B8B789E45844E7EC5DEAD89D05993B4D5@satlexdag05.amd.com>
	<819514162.3896.1413218662504.open-xchange@app06.ox.hosteurope.de>
	<A3397C8B8B789E45844E7EC5DEAD89D05993B523@satlexdag05.amd.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;henning@hennsch.de;1413222896;a13ef107;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2014 17:31:12 +0000
"Deucher, Alexander" <Alexander.Deucher@amd.com> wrote:

> Ah, ok.  The attached patches should do the trick then.

Yes that would do the trick. But i suggest doing the NULL initialization
in drm_edid_to_speaker_allocation.
The kernel doc suggests that whatever drm_edid_to_speaker_allocation
returns should be freed. Depending on which version you prefer, the
doc might have to be changed as well.

Henning
