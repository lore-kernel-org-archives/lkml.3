Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab3BKTLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:11:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43266 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab3BKTLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:11:35 -0500
Message-ID: <5119425A.1090802@wwwdotorg.org>
Date: Mon, 11 Feb 2013 12:11:22 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <glikely@secretlab.ca>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
        Stephen Warren <swarren@nvidia.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH V8] kbuild: create a rule to run the pre-processor on
 *.dts files
References: <1360091188-24063-1-git-send-email-swarren@wwwdotorg.org> <20130208144527.0D8DD3E2C01@localhost> <51156D09.7060401@gmail.com> <20130208220448.EDA773E2C27@localhost> <51157F65.2050309@wwwdotorg.org>
In-Reply-To: <51157F65.2050309@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 08:45 AM, Grant Likely wrote:
> On Tue,  5 Feb 2013 12:06:28 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> Create cmd_dtc_cpp to run the C pre-processor on *.dts file before
>> passing them to dtc for final compilation. This allows the use of #define
>> and #include within the .dts file.
...
> I've applied this and was going to push it out, but I've just thought of
> a problem that could be a show stopper. ...

Grant, I notice this showed up in next-20130211 as:

22435f3 kbuild: create a rule to run the pre-processor on *.dts files

Was that intentional? I assumed you wanted me to rework this before
you'd apply it, rather than sending an incremental patch.
