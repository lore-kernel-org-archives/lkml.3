Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab3HQAdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:33:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54050 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab3HQAdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:33:08 -0400
Message-ID: <520EB2FE.2030903@wwwdotorg.org>
Date: Fri, 16 Aug 2013 17:17:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Josh Cartwright <joshc@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] spmi: document the PMIC arbiter SPMI bindings
References: <cover.1376596224.git.joshc@codeaurora.org> <b639088d50df93caaef8fe7e09c12953b1153ce8.1376596224.git.joshc@codeaurora.org> <D1534646-7CB5-4EE7-8C1E-1C607BE22396@codeaurora.org> <20130816192549.GG4035@joshc.qualcomm.com> <A1FAB0A0-C205-4401-838C-B745B5B95FF3@codeaurora.org>
In-Reply-To: <A1FAB0A0-C205-4401-838C-B745B5B95FF3@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 01:48 PM, Kumar Gala wrote:
> 
> On Aug 16, 2013, at 2:25 PM, Josh Cartwright wrote:
> 
>> Hey Kumar-
>>
>> Thanks for the review.
>>
>> On Fri, Aug 16, 2013 at 01:53:27PM -0500, Kumar Gala wrote:
>>> On Aug 9, 2013, at 3:37 PM, Josh Cartwright wrote:
>>>
>>>> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
>>>> ---
>>>> .../devicetree/bindings/spmi/spmi-pmic-arb.txt     | 26 ++++++++++++++++++++++
>>>> 1 file changed, 26 insertions(+)
>>>> create mode 100644 Documentation/devicetree/bindings/spmi/spmi-pmic-arb.txt
>>>
>>> As this is a qcom specific binding, I think the file name should be msm-spmi-pmic-arb.txt or something like that.
>>
>> Agreed.  It might be nice to use a vendor prefix in the name too.  How's qcom,msm-pmic-arb.txt sound?
> 
> Sounds good, as I see we have other examples of having a comma in file names for bindings.

The rule I've applied for bindings I created is use the complete
compatible value for the file name. Where multiple are supported (e.g.
SoC versions), just use the first one. Then, the filename is pretty
unambiguous, both from a point of view of `ls` and from choosing a name.
