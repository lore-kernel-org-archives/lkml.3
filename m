Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaBYLQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:16:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50119 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaBYLQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:16:19 -0500
Message-ID: <1393326954.4156.3.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 0/6] ARM: STi reset controller support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: srinivas kandagatla <srinivas.kandagatla@st.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephen.gallimore@st.com, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 25 Feb 2014 12:15:54 +0100
In-Reply-To: <530C76F0.8000909@st.com>
References: <1389696613-19683-1-git-send-email-srinivas.kandagatla@st.com>
						<1391437665-11913-1-git-send-email-srinivas.kandagatla@st.com>
					<1391592486.11239.4.camel@pizza.hi.pengutronix.de>
				 <52F4D76F.8070301@st.com> <5304B849.2080806@st.com>
			 <1393237988.3091.14.camel@pizza.hi.pengutronix.de>
			 <530B514A.4070209@st.com>
		 <1393254982.3091.44.camel@pizza.hi.pengutronix.de>
		 <530C5D8C.1080809@st.com>
	 <1393321661.4156.2.camel@pizza.hi.pengutronix.de> <530C76F0.8000909@st.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srinivas,

Am Dienstag, den 25.02.2014, 10:56 +0000 schrieb srinivas kandagatla:
> Thankyou Philipp,
> On 25/02/14 09:47, Philipp Zabel wrote:
> >> No, the context is lost, the IP needs re-initialization.
> > alright then, I'll add them to the queue.
> Thats Great..
> Can I ask your Ack on these patches so that I can request Arnd/Olof to
> take these patches via arm-soc tree.
> 
> Hi Arnd/Olof,
> 
> I have few more DT patches which depend on the reset controller header
> file. Is is possible to take the reset controller patches with Philipp's
> Acks via arm-soc tree?

That's fine with me, too. Shall I back the patches out of the reset
queue, then?

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

