Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3J2Fue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:50:34 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:63376 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3J2Fuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:50:32 -0400
MIME-Version: 1.0
In-Reply-To: <3518ab21e436f5c1a7bdd900a796bb05f9162bbf.1382985169.git.joshc@codeaurora.org>
References: <cover.1382985169.git.joshc@codeaurora.org>
	<3518ab21e436f5c1a7bdd900a796bb05f9162bbf.1382985169.git.joshc@codeaurora.org>
Date: Tue, 29 Oct 2013 00:50:30 -0500
Message-ID: <CAL_Jsq+n_cAGXJaxPrRNOeb1-39EMWokCEFJ3Z3OQydJaRbijQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] of: Add empty for_each_available_child_of_node()
 macro definition
From: Rob Herring <robherring2@gmail.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 1:12 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> From: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
> Add this empty macro definition so users can be compiled without
> excluding this macro call with preprocessor directives when CONFIG_OF
> is disabled.
>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

I'm assuming the rest of this is not going to make 3.13, so I've
applied this for 3.13.

Rob
