Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3I3Aqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:46:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16401 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3I3Aq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:46:27 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-3a-5248c9d81743
From: Jingoo Han <jg1.han@samsung.com>
To: "'Axel Lin'" <axel.lin@ingics.com>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
 <003c01ceba8d$79872c60$6c958520$%han@samsung.com>
 <CAFRkauBTZQzSKgaNg781zsTU4u9V4rYATcWzC=BkJQy07sOBqA@mail.gmail.com>
 <004101ceba90$50592700$f10b7500$%han@samsung.com>
 <CAFRkauBbwEEaCiP2bnm57jB6KR0fySgsyk4S4oRLwF_=bqwncA@mail.gmail.com>
In-reply-to: <CAFRkauBbwEEaCiP2bnm57jB6KR0fySgsyk4S4oRLwF_=bqwncA@mail.gmail.com>
Subject: Re: [PATCH V3 12/14] regulator: tps6524x: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:46:16 +0900
Message-id: <007301cebd76$78543c20$68fcb460$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66kZfKeQYhPYapQs2Nnb4mWN3d2gC5IsxQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zQ90bJz2CDHZtVbA4Mucrs8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2CxO/ulldGDz2DnrLrtH288yj02rOtk87lzbw+bRt2UVo8fnTXIB
	bFFcNimpOZllqUX6dglcGc92T2Ip6GWpOHhsInMDYx9zFyMnh4SAicSyrbtZIGwxiQv31rN1
	MXJxCAksY5RY0H+PqYuRA6yo9bsCRHw6o0THxweMEM4vRonWy5MYQbrZBNQkvnw5zA5iiwio
	SLzpf8UEYjML7GGU6F+tC9GwmUni+8G9YA2cAsES35asZAOxhQUCJC4tngDWzCKgKvH/wkqw
	k3gFbCUOLmxkh7AFJX5MvscCMVRLYv3O41AL5CU2r3nLDHGpusSjv7oQNxhJ3HgwixGiRERi
	34t3YEdLCLxklziyejUzxC4BiW+TD7FA9MpKbDoADRVJiYMrbrBMYJSYhWTzLCSbZyHZPAvJ
	igWMLKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQqK3fwfj3QPWhxiTgdZPZJYSTc4HRn9e
	SbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjLbr09
	V+t//fN2t3cvcycXZS1QXX/+Ca/LhJnq+t+nBO/dX/z+UUNE6IO9x9a77PnI6upZXDT5PEf5
	5PT+a11Mzs38Iqfj2JZ/WL9MTmBy5YvuaG/m0Ntd4lJqRlMvl/cnLz/ibae9J2DO0l1JbOkq
	+5m3zfS0dPgcFmBYuG7epSKNA5tmNE5VYinOSDTUYi4qTgQAwPomnvQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQd0bJz2CDI4ekrE4Mucrs8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2CxO/ulldGDz2DnrLrtH288yj02rOtk87lzbw+bRt2UVo8fnTXIB
	bFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDOe7Z7EUtDLUnHw2ETmBsY+
	5i5GDg4JAROJ1u8KXYycQKaYxIV769m6GLk4hASmM0p0fHzACOH8YpRovTyJEaSKTUBN4suX
	w+wgtoiAisSb/ldMIDazwB5Gif7VuhANm5kkvh/cC9bAKRAs8W3JSjYQW1ggQOLS4glgzSwC
	qhL/L6xkAbF5BWwlDi5sZIewBSV+TL7HAjFUS2L9zuNQC+QlNq95C3W1usSjv7oQNxhJ3Hgw
	ixGiRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZwangmtYNxZYPFIUYBDkYlHt4Jyz2ChFgTy4orcw8xSnAwK4nwLk8CCvGmJFZWpRblxxeV
	5qQWH2JMBnp0IrOUaHI+MG3llcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1
	CGYLEwenVAPj2dnVPoyarL91Ej09Ej7eaWz8xV3yhsuoetmfbxlzZrDJ65nOmybgHl+2yi6j
	124u4w9NsU7HVdpLt7WUaum+33r1YlbKUtnqq6vzGdvy8l9Naa89n5qqZuNomWGQ5+24wf9R
	uf6dv+uPXv2Q8DPZpUB/75FjL22OHBIr2vBddm/dpjWbF8krsRRnJBpqMRcVJwIABuUFXVED	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 5:23 PM, Axel Lin wrote:
> 
> > Hi Axel,
> >
> > I really appreciate your comment.
> >
> > Then, you mean the following.
> > If I am wrong, please let me know. :-)
> > Thank you.
> 
> Then you can remove pmic_remove() function,like below diff.
> With these change, you can add Reviewed-by: Axel Lin <axel.lin@ingics.com>
> 

OK, I will fix it as you guided.
I will send V4 patch series soon.
Thank you for your kind and detailed guidance. :-)


Best regards,
Jingoo Han

