Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbaA1RGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:06:45 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:63581 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbaA1RGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:06:43 -0500
MIME-Version: 1.0
In-Reply-To: <52E7DDAD.1030309@wwwdotorg.org>
References: <1390878720-8676-1-git-send-email-badarkhe.manish@gmail.com>
	<52E7DDAD.1030309@wwwdotorg.org>
Date: Tue, 28 Jan 2014 22:36:42 +0530
Message-ID: <CAKDJKT53m=CmM2pafS9p-XJeg4LBrhSEJoFn_V-wnniNSQ7x7w@mail.gmail.com>
Subject: Re: [PATCH V2] regulator: fixed: update to devm_* API
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-omap@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan,

On Tue, Jan 28, 2014 at 10:11 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/27/2014 08:12 PM, Manish Badarkhe wrote:
>> Update the code to use devm_* API so that driver core will manage
>> resources.
>
> I'm not sure why this patch is sent to linux-tegra@vger.kernel.org; it
> seems nothing to do with Tegra (or Samsung or OMAP for that matter).

Sorry, for the noise. I sent it to have review comments from community.

Regards
Manish Badarkhe
