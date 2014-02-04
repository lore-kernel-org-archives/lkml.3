Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaBDRJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:09:54 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42424 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaBDRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:09:51 -0500
Message-ID: <52F11EDB.6020500@wwwdotorg.org>
Date: Tue, 04 Feb 2014 10:09:47 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: Re: [PATCH v2] pinctrl: protect pinctrl_list add
References: <20140203113900.GD1725@redhat.com> <52F00653.40802@wwwdotorg.org> <20140204080105.GA1428@redhat.com> <20140204080709.GB1428@redhat.com>
In-Reply-To: <20140204080709.GB1428@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 01:07 AM, Stanislaw Gruszka wrote:
> We have few fedora bug reports about list corruption on pinctrl,
> for example:
> https://bugzilla.redhat.com/show_bug.cgi?id=1051918
> 
> Most likely corruption happen due lack of protection of pinctrl_list
> when adding new nodes to it. Patch corrects that.
> 
> Fixes: 42fed7ba44e ("pinctrl: move subsystem mutex to pinctrl_dev struct")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Stephen  Warren <swarren@nvidia.com>
(but not tested)
